# Containerized PX4 SITL Run Script

- Further documentation will be made.

## Troubleshooting

### ROS2 Related

#### Issue that user can not read the subscribed topic

- **First, you can check `PX4_UXRCE_DDS_NS`**
  - Namespace which include chatacter `-`(Dash) can be the cause.
  - You can use `_`(Underbar) instead.
- **Or, QoS settings can also be the reason.**
  - PX4 developer guide suggests this. You can read [this](https://docs.px4.io/main/en/ros/ros2_comm.html#ros-2-subscriber-qos-settings).