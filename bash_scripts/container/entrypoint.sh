#!/bin/bash

set -e

# setup environment
source "$HOME/.bashrc"
{

   echo "function s(){  tmule -c ~/configs/launch.yaml -W 3 launch ; }" >> /home/ros/.bashrc
   echo "function t(){  tmule -c ~/configs/launch.yaml terminate ; }" >> /home/ros/.bashrc
   echo "function r(){  tmule -c ~/configs/launch.yaml -W 3 relaunch ; }" >> /home/ros/lcastor/.bashrc

} || {

  echo "Container failed."
  exec "$@"

}
