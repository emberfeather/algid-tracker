<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="configureApplication" access="public" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		<cfset var i18n = '' />
		
		<cfset i18n = arguments.newApplication.managers.singleton.getI18N() />
		
		<cfset temp = arguments.newApplication.factories.transient.getServLogForTracker( variables.datasource, i18n ) />
		
		<cfset arguments.newApplication.managers.singleton.setEventLog( temp ) />
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<!--- fresh => 0.1.000 --->
		<cfif arguments.installedVersion EQ ''>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_000() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.000
	--->
	<cffunction name="postgreSQL0_1_000" access="public" returntype="void" output="false">
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
				"timestamp" timestamp without time zone NOT NULL DEFAULT now(),
				"ipAddress" inet NOT NULL,
				"plugin" character varying(30) NOT NULL,
				"key" character varying(75),
				"userID" integer,
				"details" character varying(500) NOT NULL,
				CONSTRAINT tracker_event_PK PRIMARY KEY ("timestamp", "ipAddress")
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