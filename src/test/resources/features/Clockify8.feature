Feature: Clockify 8

  Background:
    Given base url https://api.clockify.me/api
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz

  @getAllWorkspaces
  Scenario: getAllWorkspaces
    Given base url https://api.clockify.me/api
    And endpoint /v1/workspaces
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    When execute method GET
    Then the status code should be 200
    And response should be $.[0].name = A
    * define idworkspace = $.[0].id

  @getWorkspaceInfo
  Scenario: getWorkspaceInfo
    Given call Clockify.feature@getAllWorkspaces
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{idworkspace}}
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    When execute method GET
    Then the status code should be 200

  @addANewProject
  Scenario: addANewProject
    Given call Clockify.feature@getWorkspaceInfo
    And endpoint /v1/workspaces/{{idworkspace}}/projects
    And header Content-Type = application/json
    And set value "Crowdar3" of key name in body jsons/bodies/addANewProject.json
    When execute method POST
    Then the status code should be 201
    * define idproject = $.id

  @FindProjectByID
  Scenario: FindProjectByID
    Given call Clockify.feature@addANewProject
    And base url https://api.clockify.me/api
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    When execute method GET
    Then the status code should be 200

  @UpdateProjectOnWorkspace
  Scenario: UpdateProjectOnWorkspace
    Given call Clockify.feature@FindProjectByID
    And base url https://api.clockify.me/api
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    And endpoint /v1/workspaces/{{idworkspace}}/projects/{{idproject}}
    And header Content-Type = application/json
    And set value "EjemplodeNota" of key note in body jsons/bodies/UpdateProjectOnWorkspace.json
    When execute method PUT
    Then the status code should be 200
    And response should be $.note = EjemplodeNota

  @addANewProjectNoAutorizado
  Scenario: addANewProjectNoAutorizado
    Given call Clockify.feature@getWorkspaceInfo
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTA
    And endpoint /v1/workspaces/{{idworkspace}}/projects
    And header Content-Type = application/json
    And set value "Crowdar3" of key name in body jsons/bodies/addANewProject.json
    When execute method POST
    Then the status code should be 401

  @addANewProjectBadRequest
  Scenario: addANewProjectBadRequest
    Given call Clockify.feature@getWorkspaceInfo
    And endpoint /v1/workspaces/{{idworkspace}}/projects
    And header Content-Type = application/json
    And set value "Crowdar3" of key name in body jsons/bodies/addANewProjectBadRequest.json
    When execute method POST
    Then the status code should be 400

  @addANewProjectNotFound
  Scenario: addANewProjectNotFound
    Given call Clockify.feature@getWorkspaceInfo
    And endpoint /v1/workspaces/{{idworkspace}}/projectsx
    And header Content-Type = application/json
    And set value "Crowdar3" of key name in body jsons/bodies/addANewProject.json
    When execute method POST
    Then the status code should be 404