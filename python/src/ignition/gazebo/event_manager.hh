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

#ifndef IGNITION_GAZEBO_PYTHON__EVENT_MANAGER_HPP_
#define IGNITION_GAZEBO_PYTHON__EVENT_MANAGER_HPP_

#include <pybind11/pybind11.h>

namespace py = pybind11;

namespace ignition
{
namespace gazebo
{
namespace python
{
/// Define a pybind11 wrapper for an ignition::gazebo::EventManager
/**
 * \param[in] module a pybind11 module to add the definition to
 */
void
define_gazebo_event_manager(py::object module);

}  // namespace python
}  // namespace gazebo
}  // namespace ignition

#endif  // IGNITION_GAZEBO_PYTHON__EVENT_MANAGER_HPP_
