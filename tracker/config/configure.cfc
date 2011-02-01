<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="onApplicationStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<cfset temp = arguments.theApplication.factories.transient.getServLogForTracker( { theApplication = arguments.theApplication } ) />
		
		<cfset arguments.theApplication.managers.singleton.setEventLog( temp ) />
	</cffunction>
<cfscript>
	public void function onRequestStart(required struct theApplication, required struct theSession, required struct theRequest, required string targetPage) {
		var temp = '';
		
		// Create a profiler object
		temp = arguments.theApplication.factories.transient.getProfiler(arguments.theApplication.managers.singleton.getApplication().isDevelopment());
		
		arguments.theRequest.managers.singleton.setProfiler( temp );
	}
</cfscript>
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<cfset var versions = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- fresh => 0.1.0 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.0') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_0() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.0
	--->
	<cffunction name="postgreSQL0_1_0" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Tracker schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#tracker"
				AUTHORIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#tracker" IS 'Tracker Plugin Schema';
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Event Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#tracker"."event"
			(
				"timestamp" timestamp without time zone not NULL DEFAULT now(),
				"ipAddress" inet not NULL,
				"plugin" character varying(30) not NULL,
				"key" character varying(75),
				"userID" uuid,
				"itemID" uuid,
				"details" character varying(500) not NULL,
				CONSTRAINT tracker_event_PK PRIMARY KEY ("timestamp", "ipAddress"),
				CONSTRAINT "event_userID_FK" FOREIGN KEY ("userID")
					REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
					ON UPDATE NO ACTION ON DELETE NO ACTION
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker"."event" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#tracker"."event" IS 'Tracker Event Log';
		</cfquery>
		
		<!---
			INDEXES
		--->
		
		<cfquery datasource="#variables.datasource.name#">
			CREATE INDEX "tracker_event_key_I"
				ON "#variables.datasource.prefix#tracker"."event"
				USING btree
				("plugin", "key");
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker"."event" CLUSTER ON "tracker_event_key_I";
		</cfquery>
	</cffunction>
</cfcomponent>