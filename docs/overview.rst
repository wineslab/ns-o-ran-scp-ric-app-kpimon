.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. SPDX-License-Identifier: CC-BY-4.0
.. Copyright (C) 2020 AT&T Intellectual Property

KPIMON Overview
==================

KPIMON is an Xapp in the traffic steering O-RAN use case.
There are four total Xapps:

1. Traffic steering, which sends "prediction requests" to QP Driver

2. QP Driver which fetches data from SDL[4] on behalf of traffic steering, both UE Data and Cell Data, merges that data together, then sends off the data to the QP Predictor

3. QP Predictor which predicts and sends that prediction back to Traffic Steering

4. KPIMONN which collects UE/Cell metrics from base station and populates SDL in the first place  (this)

So in summary, the KPIMON xapp is a helper function that receives RAN metrics and write to SDL
