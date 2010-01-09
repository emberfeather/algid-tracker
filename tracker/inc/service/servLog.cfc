<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="logEvent" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="string" required="true" />
		<cfargument name="key" type="string" required="true" />
		<cfargument name="details" type="string" required="true" />
		<cfargument name="userID" type="string" default="" />
		<cfargument name="itemID" type="string" default="" />
		<cfargument name="ipAddress" type="string" default="#CGI.REMOTE_ADDR#" />
		
		<!--- TODO For Dev use an alternative if it isn't a good IP...fix this?! --->
		<cfif arguments.ipAddress eq '0:0:0:0:0:0:0:1%0'>
			<cfset arguments.ipAddress = CGI.LOCAL_ADDR />
		</cfif>
		
		<!--- Log it quickly! --->
		<cfquery datasource="#variables.datasource.name#">
			INSERT INTO "#variables.datasource.prefix#tracker"."event"
			(
				"ipAddress",
				"plugin",
				"key",
				"details",
				"userID",
				"itemID"
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ipAddress#" />::inet,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.plugin#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.key#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.details#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" null="#arguments.userID eq ''#" />::uuid,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemID#" null="#arguments.itemID eq ''#" />::uuid
			)
		</cfquery>
	</cffunction>
</cfcomponent>