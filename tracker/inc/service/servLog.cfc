<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="logEvent" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfargument name="details" type="string" required="true" />
		<cfargument name="userID" type="numeric" default="0" />
		<cfargument name="ipAddress" type="string" default="#CGI.REMOTE_ADDR#" />
		
		<!--- Log it quickly! --->
		<cfquery datasource="#variables.datasource.name#">
			INSERT INTO "#variables.datasource.prefix#tracker"."event"
			(
				"ipAddress",
				"plugin",
				"key",
				"details",
				"userID",
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ipAddress#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.plugin#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.details#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#" null="#arguments.userID LTE 0#" />
			)
		</cfquery>
	</cffunction>
</cfcomponent>