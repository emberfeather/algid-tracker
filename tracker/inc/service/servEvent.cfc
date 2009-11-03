<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="readEvents" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfparam name="arguments.filter.orderBy" default="" />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "timestamp", "ipAddress", "userID", "plugin", "key", "details"
			FROM "#variables.datasource.prefix#tracker"."event"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'before') AND arguments.filter.before NEQ ''>
				AND "timestamp" < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.before#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'after') AND arguments.filter.after NEQ ''>
				AND "timestamp" < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.after#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'ipAddress') AND arguments.filter.ipAddress NEQ ''>
				AND "ipAddress" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.ipAddress#" />::inet
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'subnetMask') AND arguments.filter.subnetMask NEQ ''>
				AND "ipAddress" << <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.subnetMask#" />::inet
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'plugin') AND arguments.filter.plugin NEQ ''>
				AND "plugin" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.plugin#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'key') AND arguments.filter.key NEQ ''>
				AND "key" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.key#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'keyMask') AND arguments.filter.keyMask NEQ ''>
				AND "key" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.keyMask#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'search') AND arguments.filter.search NEQ ''>
				AND (
					"details" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR "key" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'timeframe') AND arguments.filter.timeframe NEQ ''>
				AND "timestamp" >=
				<cfswitch expression="#arguments.filter.timeframe#">
					<cfcase value="day">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d', -1, now())#" />
					</cfcase>
					<cfcase value="week">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('ww', -1, now())#" />
					</cfcase>
					<cfcase value="month">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('m', -1, now())#" />
					</cfcase>
					<cfcase value="quarter">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('m', -3, now())#" />
					</cfcase>
					<cfcase value="year">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('yyyy', -1, now())#" />
					</cfcase>
				</cfswitch>
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'userID') AND arguments.filter.userID NEQ ''>
				AND "userID" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.filter.userID#" />
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"timestamp" DESC
				</cfdefaultcase>
			</cfswitch>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="readPluginKeys" access="public" returntype="query" output="false">
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT DISTINCT "plugin", "key"
			FROM "#variables.datasource.prefix#tracker"."event"
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>