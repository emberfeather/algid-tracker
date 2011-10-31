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
		
		<!--- => 0.1.5 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.5') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_5() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
		
		<!--- => 0.1.6 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.6') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_6() />
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
	
	<!---
		Configures the database for v0.1.5
	--->
	<cffunction name="postgreSQL0_1_5" access="public" returntype="void" output="false">
		<!---
			TABLES
		--->
		
		<!--- Drop the old primary key --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker".event DROP CONSTRAINT tracker_event_PK;
		</cfquery>
		
		<!--- Add column for an id --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker".event ADD COLUMN "eventID" uuid;
		</cfquery>
		
		<!--- Make sure all the ids have a value --->
		<cfquery name="local.results" datasource="#variables.datasource.name#">
			SELECT "timestamp", "ipAddress"
			FROM "#variables.datasource.prefix#tracker".event
		</cfquery>
		
		<cfloop query="local.results">
			<cfquery datasource="#variables.datasource.name#">
				UPDATE "#variables.datasource.prefix#tracker".event
				SET "eventID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#" />::uuid
				WHERE "timestamp" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#local.results.timestamp#">
					AND "ipAddress" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.results.ipAddress.toString()#">::inet
			</cfquery>
		</cfloop>
		
		<!--- Remove any errant nulls --->
		<cfquery datasource="#variables.datasource.name#">
			DELETE
			FROM "#variables.datasource.prefix#tracker".event
			WHERE "eventID" IS NULL
		</cfquery>
		
		<!--- Make Event ID not NULL --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker".event ALTER COLUMN "eventID" SET NOT NULL;
		</cfquery>
		
		<!--- Create new primary ID --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker".event ADD PRIMARY KEY ("eventID");
		</cfquery>
	</cffunction>
	
	<!---
		Configures the database for v0.1.6
	--->
	<cffunction name="postgreSQL0_1_6" access="public" returntype="void" output="false">
		<!---
			Timestamps
		--->
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker"."event" ALTER "timestamp" TYPE timestamp with time zone;
		</cfquery>
	</cffunction>
</cfcomponent>