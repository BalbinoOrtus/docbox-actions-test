/**
* My BDD Test
*/
component extends="testbox.system.BaseSpec"{

	property name="testOutputDir" default="/tests/resources/tmp/json";

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.docbox = new docbox.DocBox(
			strategy = "docbox.strategy.json.JSONAPIStrategy",
			properties={ 
				projectTitle 	= "DocBox Tests",
				outputDir 		= variables.testOutputDir
			}
		);
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		structDelete( variables, "docbox" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.
		describe( "JSONAPIStrategy", function(){

			beforeEach( function() {
				// empty the directory so we know if it has been populated
				if ( directoryExists( variables.testOutputDir ) ){
					directoryDelete( variables.testOutputDir, true );
				}
				directoryCreate( variables.testOutputDir );
			});

			it( "can run without failure", function(){
				expect( function() {
					variables.docbox.generate(
						source = expandPath( "/tests" ),
						mapping = "tests",
						excludes="(coldbox|build\-docbox)"
					)
				}
				).notToThrow();
			});

			it( "produces JSON output in the correct directory", function() {
				variables.docbox.generate(
					source = expandPath( "/tests" ),
					mapping = "tests",
					excludes="(coldbox|build\-docbox)"
				);

				var results = directoryList( variables.testOutputDir, true, "name" );
				debug( results );
				expect( results.len() ).toBeGT( 0 );

				expect( arrayContainsNoCase( results, "index.json" ) )
					.toBeTrue( "should generate index.json class index file" );
				expect( arrayContainsNoCase( results, "classes" ) )
					.toBeTrue( "should generate classes/ directory for class documentation");
				expect( arrayContainsNoCase( results, "JSONAPIStrategyTest.json" ) )
					.toBeTrue( "should generate classes/JSONAPIStrategyTest.json to document JSONAPIStrategyTest.cfc")

			});

		});
	}

}

