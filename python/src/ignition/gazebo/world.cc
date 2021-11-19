// Copyright 2021 Open Source Robotics Foundation, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <pybind11/pybind11.h>

#include <iostream>

#include "world.hh"

namespace ignition
{
namespace gazebo
{
namespace python
{
World::World(ignition::gazebo::Entity _entity)
{
  _world = std::make_shared<ignition::gazebo::World>(_entity);
}

World::~World()
{
}

void World::destroy()
{
  _world.reset();
}

ignition::math::Vector3<double> World::Gravity(const EntityComponentManager &_ecm)
{
  std::optional<ignition::math::Vector3d> gravity = _world->Gravity(*_ecm.rcl_ptr());
  if (gravity.has_value())
  {
    return gravity.value();
  }
  return ignition::math::Vector3d::NaN;
}

ignition::gazebo::Entity World::ModelByName(
  ignition::gazebo::python::EntityComponentManager &_ecm,
  std::string _name)
{
  return _world->ModelByName(*_ecm.rcl_ptr(), _name);
}

void define_gazebo_world(py::object module)
{
  py::class_<ignition::gazebo::python::World,
             ignition::utils::python::Destroyable,
             std::shared_ptr<ignition::gazebo::python::World>>(module, "World")
  .def(py::init<ignition::gazebo::Entity>())
  .def(
    "model_by_name", &ignition::gazebo::python::World::ModelByName,
    "Get the ID of a model entity which is an immediate child of "
    " this world.")
  .def(
    "gravity", &ignition::gazebo::python::World::Gravity,
    "Get the gravity in m/s^2.");
}

}  // namespace python
}  // namespace gazebo
}  // namespace ignition
