/* $Id$ */

/*
	Scalable Building Simulator - Sound System
	The Skyscraper Project - Version 1.10 Alpha
	Copyright (C)2004-2015 Ryan Thoryk
	http://www.skyscrapersim.com
	http://sourceforge.net/projects/skyscraper
	Contact - ryan@tliquest.net

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#include "globals.h"
#include "sbs.h"
#include "soundsystem.h"
#include "unix.h"

namespace SBS {

SoundSystem::SoundSystem(FMOD::System *fmodsystem)
{
	SetValues(sbs, "SoundSystem", "Sound System", true, false);

	soundsys = fmodsystem;

	listener_position.x = 0;
	listener_position.y = 0;
	listener_position.z = 0;
	listener_velocity.x = 0;
	listener_velocity.y = 0;
	listener_velocity.z = 0;
	listener_forward.x = 0;
	listener_forward.y = 0;
	listener_forward.z = 0;
	listener_up.x = 0;
	listener_up.y = 0;
	listener_up.z = 0;

	//set up sound options (mainly to set sound distance factor to feet instead of meters)
	soundsys->set3DSettings(1.0f, 3.28f, 1.0f);
}

SoundSystem::~SoundSystem()
{
	for (int i = 0; i < (int)sounds.size(); i++)
		delete sounds[i];
}

void SoundSystem::Loop()
{
	//update sound
	if (sbs->enable_advanced_profiling == false)
		ProfileManager::Start_Profile("Sound");
	else
		ProfileManager::Start_Profile("FMOD");
	soundsys->update();
	ProfileManager::Stop_Profile();
}

void SoundSystem::SetListenerPosition(const Ogre::Vector3 &position)
{
	//set position of sound listener object

	unsigned int timing;
	if (sbs->SmoothFrames > 0)
		timing = sbs->GetAverageTime();
	else
		timing = sbs->GetElapsedTime();

	//calculate sound velocity
	if (timing > 0)
	{
		listener_velocity.x = (position.x - listener_position.x) * (1000 / timing);
		listener_velocity.y = (position.y - listener_position.y) * (1000 / timing);
		listener_velocity.z = (position.z - listener_position.z) * (1000 / timing);
	}

	listener_position.x = position.x;
	listener_position.y = position.y;
	listener_position.z = position.z;

	soundsys->set3DListenerAttributes(0, &listener_position, &listener_velocity, &listener_forward, &listener_up);
}

void SoundSystem::SetListenerDirection(const Ogre::Vector3 &front, const Ogre::Vector3 &top)
{
	//set direction of sound listener object
	listener_forward.x = front.x;
	listener_forward.y = front.y;
	listener_forward.z = front.z;
	listener_up.x = top.x;
	listener_up.y = top.y;
	listener_up.z = top.z;

	soundsys->set3DListenerAttributes(0, &listener_position, &listener_velocity, &listener_forward, &listener_up);
}

void SoundSystem::Cleanup()
{
	//unloads sounds that are not associated with any channels

	for (int i = 0; i < (int)sounds.size(); i++)
	{
		if (sounds[i]->channels.size() == 0)
		{
			if (sounds[i]->sound)
				sounds[i]->sound->release();

			delete sounds[i];
			sounds.erase(sounds.begin() + i);
			i--;
		}
	}
}

unsigned int SoundSystem::GetLength(SoundData *sound)
{
	//get length of sound in milliseconds

	if (!sound)
		return 0;

	unsigned int length;
	sound->sound->getLength(&length, FMOD_TIMEUNIT_MS);
	return length;
}

SoundSystem::SoundData* SoundSystem::Load(const std::string &filename)
{
	//load a sound file from specified filename

	//exit if none specified
	if (filename == "")
		return 0;

	//exit if mp3 file specified
	if (FindWithCase(filename, false, ".mp3", (int)filename.size() - 4) > 0)
		return 0;

	//return existing data element if file is already loaded
	SoundData *existing = GetSoundData(filename);
	if (existing)
		return existing;

	//create new SoundData element
	SoundData *data = new SoundData();
	data->filename = SetCaseCopy(filename, false);

	//load new sound
	std::string full_filename1 = "data/";
	full_filename1.append(filename);
	std::string full_filename = sbs->VerifyFile(full_filename1);

	FMOD_RESULT result = soundsys->createSound(full_filename.c_str(), (FMOD_MODE)(FMOD_3D | FMOD_ACCURATETIME | FMOD_SOFTWARE | FMOD_LOOP_NORMAL), 0, &data->sound);
	//FMOD_RESULT result = soundsys->createStream(full_filename.c_str(), (FMOD_MODE)(FMOD_SOFTWARE | FMOD_3D), 0, &data.sound); //streamed version
	if (result != FMOD_OK)
	{
		ReportError("Can't load file '" + filename + "'");
		return 0;
	}

	//add sound element to array
	sounds.push_back(data);

	return data;
}

bool SoundSystem::IsLoaded(std::string filename)
{
	//return true if a specific file is already loaded

	SetCase(filename, false);
	for (int i = 0; i < (int)sounds.size(); i++)
	{
		std::string check = sounds[i]->filename;

		if (check == filename)
			return true;
	}
	return false;
}

FMOD::Channel* SoundSystem::Prepare(SoundData *sound)
{
	//prepare a sound for play - this allocates a channel

	if (!sound)
		return 0;

	FMOD::Channel *channel = 0;
	FMOD_RESULT result = soundsys->playSound(FMOD_CHANNEL_FREE, sound->sound, true, &channel);

	if (result != FMOD_OK || !channel)
		return 0;

	sound->channels.push_back(channel);

	return channel;
}

SoundSystem::SoundData* SoundSystem::GetSoundData(std::string filename)
{
	//get sound data element for related filename

	SetCase(filename, false);
	for (int i = 0; i < (int)sounds.size(); i++)
	{
		if (sounds[i]->filename == filename)
			return sounds[i];
	}
	return 0;
}

void SoundSystem::Report(const std::string &message)
{
	sbs->Report("Sound System: " + message);
}

bool SoundSystem::ReportError(const std::string &message)
{
	return sbs->ReportError("Sound System: " + message);
}

SoundSystem::SoundData::SoundData()
{
	sound = 0;
}

SoundSystem::SoundData::~SoundData()
{
	if (sound)
		sound->release();
	sound = 0;
}

void SoundSystem::SoundData::RemoveChannel(FMOD::Channel* channel)
{
	//remove a channel entry

	for (int i = 0; i < (int)channels.size(); i++)
	{
		if (channels[i] == channel)
		{
			channels.erase(channels.begin() + i);
			return;
		}
	}
}

}
