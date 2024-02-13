= Extension Ideas

== Ideas for how to improve the gbpplanner paper/code

- Communication
  - Distributed
  - What happens if there are no "InterRobot" factors
  - What happens if there is no communication available for a certain amount of
    time?
    - According to @gbpplanner their algorithm does well even when a given percentage
      of messages does not arrive?

- Handle dynamic elements that are not robots. E.g. a human operator walking in
  the environment. Can just be modelled as a robot that can not be communicated
  with.

- Simulate Sensors instead of using a static Signed Distance Field (SDF) map of
  the environment.
  - Simulate a lidar using raycasting
  - Depth Camera

- Planning
  - Have a combination of a local and a global planner.

- Environment
  - Ask Beumer about a typical layout for their sorting facility, and use that as a
    more complex albeit realistic challenging environment.

- Extend to handle 3D scenarios

- Reproduce for the purpose of implementing a full-fledged solution.
  - Airport scenario
  - Logistics scenario

#bibliography(
  "./references.yaml",
  style: "institute-of-electrical-and-electronics-engineers",
)
