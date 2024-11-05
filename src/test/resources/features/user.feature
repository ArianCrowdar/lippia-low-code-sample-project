Feature: user

  Background:
    Given base url https://api.clockify.me/api
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz

@findAllUsersOnWorkspace
Scenario: findAllUsersOnWorkspace
Given call Clockify8.feature@getAllWorkspaces
And base url https://api.clockify.me/api
And endpoint /v1/workspaces/{{idworkspace}}/users
And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
When execute method GET
Then the status code should be 200
* define iduser = $.[0].id
* define idworkspace = $.[0].activeWorkspace