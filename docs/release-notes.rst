.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. SPDX-License-Identifier: CC-BY-4.0
.. Copyright (C) 2020 AT&T Intellectual Property

Release Notes
===============

All notable changes to this project will be documented in this file.

The format is based on `Keep a Changelog <http://keepachangelog.com/>`__
and this project adheres to `Semantic Versioning <http://semver.org/>`__.


[1.0.1] - 1/20/2021
--------------------

* Use SDL lib to replace direct use of Redis client
* Add xapp descriptor


[1.0.0] - 12/16/2020
--------------------

* Update builder image
* Change key name


[0.4.0] - 11/27/2020
------------------

* Fix RIC_INDICATION RANContainer decoding issue
* Fix data format issue when storing data into DB


[0.3.0] - 10/16/2020
------------------

* Fix interface type issue when decoding RIC_INDICATION
* Integration test with e2sim


[0.2.0] - 7/17/2020
------------------

* CI config
* Add memory free function for E2AP/E2SM encoding and decoding
* Log output
* Code optimization


[0.1.0] - 4/21/2020
-------------------

* RIC_INDICATION
* Store UE/Cell metrics into Redis DB
* Small cleanups


[0.0.2] - 3/25/2020
-------------------

* RIC_SUB_REQ
* Helm chart
* Dockerfile


[0.0.1] - 3/10/2020
-------------------

* inital skeleton creation
