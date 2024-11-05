Feature: timeEntry

  Background:
    Given base url $(env.base_url_clockify)
     And header x-api-key = $(env.api_key_clockify)

  @getTimeEntriesForAUserOnWorkspace
  Scenario: getTimeEntriesForAUserOnWorkspace
    Given call user.feature@findAllUsersOnWorkspace
    And endpoint /v1/workspaces/{{idworkspace}}/user/{{iduser}}/time-entries
    When execute method GET
    Then the status code should be 200
    * define idtime = $.[0].id

  @addANewTimeEntry
  Scenario: addANewTimeEntry
    Given call Clockify8.feature@getAllWorkspaces
    And endpoint /v1/workspaces/{{idworkspace}}/time-entries
    And header Content-Type = application/json
    And body jsons/bodies/addANewTimeEntry.json
    When execute method POST
    Then the status code should be 201

  @updateTimeEntryOnWorkspace
  Scenario: updateTimeEntryOnWorkspace

    Given call timeEntry.feature@getTimeEntriesForAUserOnWorkspace
    And endpoint /v1/workspaces/{{idworkspace}}/time-entries/{{idtime}}
    And header Content-Type = application/json
    And body jsons/bodies/updateTimeEntryOnWorkspace.json
    When execute method PUT
    Then the status code should be 200

  @deleteTimeEntryFromWorkspace
  Scenario: deleteTimeEntryFromWorkspace

    Given call timeEntry.feature@getTimeEntriesForAUserOnWorkspace
    And endpoint /v1/workspaces/{{idworkspace}}/time-entries/{{idtime}}
    When execute method DELETE
    Then the status code should be 204




