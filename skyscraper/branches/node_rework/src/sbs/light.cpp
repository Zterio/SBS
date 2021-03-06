/* $Id$ */

/*
	Scalable Building Simulator - Light Class
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

#include <OgreLight.h>
#include "globals.h"
#include "sbs.h"
#include "unix.h"
#include "light.h"

extern SBS *sbs; //external pointer to the SBS engine

Light::Light(Object *parent, const char *name, int type, Ogre::Vector3 position, Ogre::Vector3 direction, float color_r, float color_g, float color_b, float spec_color_r, float spec_color_g, float spec_color_b, float spot_inner_angle, float spot_outer_angle, float spot_falloff, float att_range, float att_constant, float att_linear, float att_quadratic)
{
	//creates a light object

	//types are:
	//0 - point light
	//1 - directional light
	//2 - spotlight

	//set up SBS object
	SetValues(this, parent, "Light", name, false);

	Type = type;
	Name = name;

	try
	{
		light = sbs->mSceneManager->createLight(name);
		GetSceneNode()->attachObject(light);

		if (type == 0)
			light->setType(Ogre::Light::LT_POINT);
		if (type == 1)
			light->setType(Ogre::Light::LT_DIRECTIONAL);
		if (type == 2)
			light->setType(Ogre::Light::LT_SPOTLIGHT);

		SetColor(color_r, color_g, color_b, spec_color_r, spec_color_g, spec_color_b);
		Move(position);
		light->setDirection(direction * Ogre::Vector3(1, 1, -1));
		if (Type == 2)
			light->setSpotlightRange(Ogre::Degree(spot_inner_angle), Ogre::Degree(spot_outer_angle), spot_falloff);
		light->setAttenuation(sbs->ToRemote(att_range), att_constant, att_linear, att_quadratic);
	}
	catch (Ogre::Exception &e)
	{
		sbs->ReportError("Error creating light:\n" + e.getDescription());
	}
}

Light::~Light()
{
	if (light)
		GetSceneNode()->detachObject(light);
	sbs->mSceneManager->destroyLight(Name);

	//unregister from parent
	if (sbs->FastDelete == false && parent_deleting == false)
	{
		if (std::string(GetParent()->GetType()) == "Elevator")
			((Elevator*)GetParent()->GetRawObject())->RemoveLight(this);
		if (std::string(GetParent()->GetType()) == "Floor")
			((Floor*)GetParent()->GetRawObject())->RemoveLight(this);
		if (std::string(GetParent()->GetType()) == "Shaft")
			((Shaft*)GetParent()->GetRawObject())->RemoveLight(this);
		if (std::string(GetParent()->GetType()) == "Stairs")
			((Stairs*)GetParent()->GetRawObject())->RemoveLight(this);
		if (std::string(GetParent()->GetType()) == "SBS")
			sbs->RemoveLight(this);
	}
}

void Light::SetColor(float color_r, float color_g, float color_b, float spec_color_r, float spec_color_g, float spec_color_b)
{
	//set color of light
	light->setDiffuseColour(color_r, color_g, color_b);
	light->setSpecularColour(spec_color_r, spec_color_g, spec_color_b);
}
