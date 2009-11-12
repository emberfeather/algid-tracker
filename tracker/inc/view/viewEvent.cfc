<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="filterActive" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filterActive = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterActive = variables.transport.theApplication.factories.transient.getFilterActive(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterActive.addBundle('plugins/tracker/i18n/inc/view', 'viewEvent') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="pluginKeys" type="query" required="true" />
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addBundle('plugins/tracker/i18n/inc/view', 'viewEvent') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<!--- Timeframes --->
		<cfset options = variables.transport.theApplication.factories.transient.getOptions() />
		
		<cfset options.addOption('All Available', '') />
		<cfset options.addOption('Past Day', 'day') />
		<cfset options.addOption('Past Week', 'week') />
		<cfset options.addOption('Past Month', 'month') />
		<cfset options.addOption('Past Quarter', 'quarter') />
		<cfset options.addOption('Past Year', 'year') />
		
		<cfset filter.addFilter('timeframe', options) />
		
		<!--- Plugin --->
		<cfquery name="results" dbtype="query">
			SELECT DISTINCT plugin
			FROM arguments.pluginKeys
			ORDER BY plugin ASC
		</cfquery>
		
		<cfset options = variables.transport.theApplication.factories.transient.getOptions() />
		
		<cfset options.addOption('All Plugins', '') />
		
		<cfloop query="results">
			<cfset options.addOption(results.plugin, results.plugin) />
		</cfloop>
		
		<cfset filter.addFilter('plugin', options) />
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.locale) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/tracker/i18n/inc/view', 'viewEvent') />
		
		<cfset datagrid.addColumn({
				key = 'timestamp',
				label = 'timestamp'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'ipAddress',
				label = 'ipAddress',
				link = {
					'ipAddress' = 'ipAddress',
					'onPage' = 1
				}
			}) />
		
		<cfset datagrid.addColumn({
				key = 'userID',
				label = 'userID',
				link = {
					'userID' = 'userID',
					'onPage' = 1
				}
			}) />
		
		<cfset datagrid.addColumn({
				key = 'plugin',
				label = 'plugin',
				link = {
					'plugin' = 'plugin',
					'onPage' = 1
				}
			}) />
		
		<cfset datagrid.addColumn({
				key = 'key',
				label = 'key',
				link = {
					'key' = 'key',
					'onPage' = 1
				}
			}) />
		
		<cfset datagrid.addColumn({
				key = 'details',
				label = 'details'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>