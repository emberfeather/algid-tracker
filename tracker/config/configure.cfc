<cfcomponent extends="algid.inc.resource.application.configure" output="false">
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
		
		<!--- Log Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#tracker".log
			(
			  "timestamp" timestamp without time zone NOT NULL,
			  "ipAddress" inet NOT NULL,
			  "userID" integer NOT NULL,
			  "key" character varying(75),
			  title character varying(200) NOT NULL,
			  details text,
			  CONSTRAINT tracker_log_primary PRIMARY KEY ("timestamp", "ipAddress", "userID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#tracker".log OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#tracker".log IS 'Tracker Log';
		</cfquery>
	</cffunction>
</cfcomponent>