#!/bin/bash
screen -dmS test
screen -S test -p 0 -X stuff "java -Xmx500M -Xms64M -jar $HOME/mc/server.jar nogui "
screen -S test -p 0 -X stuff $'\n'
