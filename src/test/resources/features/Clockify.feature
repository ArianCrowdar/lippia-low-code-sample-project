Feature: Clockify

  //* define baseUrl = https://api.clockify.me/api
  // Given base url {{baseUrl}}
  //Given base url $(env.base_url_clockify)

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

  Scenario: addWorkspace
    Given endpoint /v1/workspaces
    And header Content-Type = application/json
    And body jsons/bodies/addWorkspace.json
    When execute method POST
    Then the status code should be 201
    * define idworkspace = $.id

  @ej3 @addClient
  Scenario: addClient
    Given call Clockify.feature@getAllWorkspaces
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{idworkspace}}/clients
    And header Content-Type = application/json
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    And body jsons/bodies/addClient.json
    When execute method POST
    Then the status code should be 201
    * define id = $.id

  @ej4 @findClient
  Scenario: findClient
    Given call Clockify.feature@getAllWorkspaces
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{idworkspace}}/clients
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    When execute method GET
    Then the status code should be 200
    * define id = $.id

  @ej5 @deleteClient
  Scenario: deleteClient
    Given call Clockify.feature@addClient
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{idworkspace}}/clients/{{id}}
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    When execute method DELETE
    Then the status code should be 200

  @ej6
  Scenario: Validar que el cliente se haya eliminado
    Given call Clockify.feature@deleteClient
    And base url https://api.clockify.me/api
    And endpoint /v1/workspaces/{{idworkspace}}/clients/{{id}}
    And header x-api-key = YmRmOTQ1ZTUtYmM2Yy00OWFhLTljOTgtYWZjYzhmOWQyNTAz
    When execute method GET
    Then the status code should be 400
    And response should be $.message = Client doesn't belong to Workspace

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
