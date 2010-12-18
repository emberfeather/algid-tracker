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
		<cfargument name="values" type="struct" default="#{}#" />
		<cfargument name="pluginKeys" type="query" required="true" />
		
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
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL(), arguments.values) />
	</cffunction>
	
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		<cfset var timeago = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		<cfset timeago = variables.transport.theApplication.managers.singleton.getTimeago() />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/tracker/i18n/inc/view', 'viewEvent') />
		
		<cfset datagrid.addColumn({
				format = 'd mmm yyyy',
				key = 'timestamp',
				label = 'date',
				type = 'date'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'userID',
				label = 'userID',
				link = {
					'userID' = 'userID',
					'onPage' = 1
				},
				type = 'uuid'
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
	
	<cffunction name="recent" access="public" returntype="string" output="false">
		<cfargument name="data" type="query" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				base = '/admin/app/events'
			} />
		<cfset var html = '' />
		<cfset var theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset var timeago = variables.transport.theApplication.managers.singleton.getTimeago() />
		
		<cfset arguments.options = extend(defaults, arguments.options) />
		
		<!--- Set a base to go to --->
		<cfset theURL.setRecentEvents('_base', arguments.options.base) />
		
		<cfsavecontent variable="html">
			<cfoutput>
				<h3><a href="#theURL.getRecentEvents()#">Recent Events</a></h3>
				
				<cfloop query="arguments.data">
					<cfset theURL.setRecentEvents('plugin', arguments.data.plugin) />
					
					<div>
						<strong>#htmlEditFormat(arguments.data.details)#</strong>
						
						<div class="small light">
							<div class="float-right">
								#timeago.toHTML(arguments.data.timestamp)#
							</div>
							
							<a href="#theURL.getRecentEvents()#">#arguments.data.plugin#</a>
						</div>
						
						<div class="clear"><!-- clear --></div>
					</div>
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
</cfcomponent>
