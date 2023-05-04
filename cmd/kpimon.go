package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"

	"gerrit.o-ran-sc.org/r/scp/ric-app/kpimon/control"
)

func main() {
	response_deregister, err := deRegisterXApp()
	if err != nil {
		print("Error: " + err.Error())
	}
	responseDeRegisterString := string(response_deregister)

	print("RESPONSE DEREGISTER POST: ")
	println(responseDeRegisterString)

	time.Sleep(5 * time.Second)

	response, err := registerXApp()
	if err != nil {
		print("Error: " + err.Error())
	}
	responseString := string(response)

	print("RESPONSE REGISTER POST: ")
	println(responseString)

	time.Sleep(5 * time.Second)

	c := control.NewControl()
	c.Run()
}

func registerXApp() ([]byte, error) {

	url := "http://service-ricplt-appmgr-http.ricplt:8080/ric/v1/register"

	// Read payload from config-file.json
	payload, err := ioutil.ReadFile("/opt/ric/config/config-file.json")
	if err != nil {
		print("Error READ CONF: " + err.Error())
	}

	hostname := os.Getenv("HOSTNAME")
	XAPP_NAME := hostname
	XAPP_VERSION := "1.0.0"
	// RICPLT_NAMESPACE := "ricplt"
	XAPP_NAMESPACE := "ricxapp"

	// http_endpoint := "SERVICE_" + strings.ToUpper(XAPP_NAMESPACE) + "_" + strings.ToUpper(XAPP_NAME) + "_HTTP_PORT"
	rmr_os_key := "SERVICE_" + strings.ToUpper(XAPP_NAMESPACE) + "_" + strings.ToUpper(XAPP_NAME) + "_RMR_PORT"
	rmr_endpoint := strings.Split(os.Getenv(rmr_os_key), "//")[1]

	config := string(payload)

	// Create new JSON
	request := map[string]interface{}{
		"appName":         hostname,
		"appVersion":      XAPP_VERSION,
		"configPath":      "",
		"appInstanceName": XAPP_NAME,
		"httpEndpoint":    "",
		"rmrEndpoint":     rmr_endpoint,
		"config":          config,
	}

	// Encode the JSON object as a string
	requestString, err := json.Marshal(request)
	if err != nil {
		fmt.Println("Error encoding JSON:", err)
		return nil, err
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(requestString))
	if err != nil {
		return nil, err
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return body, nil
}

func deRegisterXApp() ([]byte, error) {

	url := "http://service-ricplt-appmgr-http.ricplt:8080/ric/v1/deregister"

	hostname := os.Getenv("HOSTNAME")
	XAPP_NAME := hostname

	// Create new JSON
	request := map[string]interface{}{
		"appName":         hostname,
		"appInstanceName": XAPP_NAME,
	}

	// Encode the JSON object as a string
	requestString, err := json.Marshal(request)
	if err != nil {
		fmt.Println("Error encoding JSON:", err)
		return nil, err
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(requestString))
	if err != nil {
		return nil, err
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	return body, nil
}
