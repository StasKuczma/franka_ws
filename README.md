# Franka Panda ROS1 Workspace

Teleoperation workspace for the Franka Panda 7-DOF robot arm using ROS Noetic.

## Setup
1. Create src/external directory 
   ```bash
   cd franka_ws
   mkdir src/external
   ```
2. Clone there source code for teleoperation
   ```bash
   gdown <id>
   ```
3. Build the Docker image:
   ```bash
   docker build -f .docker/Dockerfile -t franka_ws .
   ```
4. Start the container:
   ```bash
   ./run.sh
   ```
   > note: running again script `run.sh` will stop and remove old container, if you wish to resume the work start the container again using `docker start franka_ws` 
5. To enter in new terminal: 
   ```bash 
   docker exec -it franka_ws bash
   ```

## Robot Control

> **Note:** Replace `192.168.1.1` with your robot's actual IP address throughout.

### Option A: Joint Trajectory Controller

**1. Launch the Franka driver:**
```bash
roslaunch franka_control franka_control.launch robot_ip:=192.168.1.1
```

or simulation 
```bash
roslaunch franka_gazebo panda.launch
```



**2. Spawn the joint trajectory controller:**
```bash
rosrun controller_manager spawner position_joint_trajectory_controller
```

**3. Send a joint position command** (example: home-ish pose):
```bash
rostopic pub /position_joint_trajectory_controller/command trajectory_msgs/JointTrajectory "header:
  seq: 0
  stamp:
    secs: 0
    nsecs: 0
  frame_id: ''
joint_names:
- 'panda_joint1'
- 'panda_joint2'
- 'panda_joint3'
- 'panda_joint4'
- 'panda_joint5'
- 'panda_joint6'
- 'panda_joint7'
points:
- positions: [-1.24715, 0.57547, 1.54540, -2.07732, -0.43934, 1.36887, -1.37637]
  time_from_start: {secs: 4, nsecs: 0}" -1
```

### Option B: MoveIt Planner

Launches the driver, MoveIt move_group, and RViz in one command:
```bash
roslaunch panda_moveit_config franka_control.launch robot_ip:=192.168.1.1 load_gripper:=true
```


## Teleop

Source you Tracikpy 
```bash
pip install -e /catkin_ws/src/external/teleop_mit_panda/src/tracikpy/
```
