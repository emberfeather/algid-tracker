<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="readEvents" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfparam name="arguments.filter.orderBy" default="" />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "timestamp", "ipAddress", "userID", "plugin", "key", "details"
			FROM "#variables.datasource.prefix#tracker"."event"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'before') and arguments.filter.before neq ''>
				and "timestamp" < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.before#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'after') and arguments.filter.after neq ''>
				and "timestamp" < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.after#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'ipAddress') and arguments.filter.ipAddress neq ''>
				and "ipAddress" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.ipAddress#" />::inet
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'subnetMask') and arguments.filter.subnetMask neq ''>
				and "ipAddress" << <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.subnetMask#" />::inet
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'plugin') and arguments.filter.plugin neq ''>
				and "plugin" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.plugin#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'key') and arguments.filter.key neq ''>
				and "key" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.key#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'keyMask') and arguments.filter.keyMask neq ''>
				and "key" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.keyMask#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and (
					"details" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					or "key" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'timeframe') and arguments.filter.timeframe neq ''>
				and "timestamp" >=
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
			
			<cfif structKeyExists(arguments.filter, 'userID') and arguments.filter.userID neq ''>
				and "userID" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.userID#" />
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"timestamp" DESC
				</cfdefaultcase>
			</cfswitch>
			
			<cfif structKeyExists(arguments.filter, 'limit')>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.limit#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'offset')>
				OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.offset#" />
			</cfif>
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