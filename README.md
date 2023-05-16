# UPDATED README

## PREREQUISITES

The near-RT-RIC has to be installed. If is not, follow the instructions here: https://docs.o-ran-sc.org/projects/o-ran-sc-ric-plt-ric-dep/en/latest/installation-guides.html

Take care in installing dms_cli, mandatory for the second part.

Chartmuseum has to be already on. If not availabe, run from the home folder:
>docker run --rm -u 0 -it -d -p 8090:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
>
In addition to that, a local Docker registry is supposed to be running at 127.0.0.1:5000. In case it is not, run:
>docker run -d -p 5000:5000 --name registry registry:2
>


## Install and launch the xApp
Just use the ./launch_app.sh script.

What the script does is:
- creating an env. variable for the url of Chartmuseum. 
- building the xApp from source and tagging it to 127.0.0.1.5000/{name-xapp}:version
- pushing the image to the registry (that's why it was tagged like that)
- Onboarding the xApp, using the tool *dms_cli* and the descriptor and validation schema. Notice that, inside, you find the image of the registry with its version. The xApp might have a different version. xApp version is a different thing than Docker image version.
- Installing the xApp in the RIC (notice that install = run)
- after 10 s, the script returns the name of the pod in the *ricxapp* namespace and the command to shell inside it
To run the kpimon: .
>/kpimon -f /opt/ric/config/config-file.json

# ORIGINAL README AND LICENSE
==================================================================================

Copyright (c) 2020 AT&T Intellectual Property.

  

Licensed under the Apache License, Version 2.0 (the "License");

you may not use this file except in compliance with the License.

You may obtain a copy of the License at

  

http://www.apache.org/licenses/LICENSE-2.0

  

Unless required by applicable law or agreed to in writing, software

distributed under the License is distributed on an "AS IS" BASIS,

WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

See the License for the specific language governing permissions and

limitations under the License.

==================================================================================

  

KPI Monitoring

================

  

This repository contains the source for the RIC KPI monitoring application.

  

This xApp can be onboarded through the xApp Onboarder. The xapp descriptor

is under the xapp-descriptor/ directory.

  

Then the xapp can be deployed through the App Manager.

  

rte|12010|service-ricplt-e2term-rmr-alpha.ricplt:38000