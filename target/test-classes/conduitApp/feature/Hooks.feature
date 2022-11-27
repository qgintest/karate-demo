@hooks
Feature: Hooks

Background: 
    # before hook, will execute before each scenario
    # * def result = call read('classpath:helpers/Dummy.feature')

    # below will execute only once before all scenarios because of callonce keyword
    # * def result = callonce read('classpath:helpers/Dummy.feature')
    # * def username = result.username

    # after hooks
    * configure afterFeature = function() {karate.call('classpath:helpers/Dummy.feature')}

    # * configure afterScenario = function() {karate.call('classpath:helpers/Dummy.feature')}
    * configure afterScenario = 
    """
        function(){
            karate.log('After Scenario Text');
        }
    """


Scenario: First scenario
      # * print username
      * print 'First'

Scenario: Second scenario
    # * print username
    * print 'Second'