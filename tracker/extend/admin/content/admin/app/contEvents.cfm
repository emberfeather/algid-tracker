<cfset viewEvent = application.factories.transient.getViewEventForTracker( theURL ) />

<cfset filter = {
	} />

<cfset events = servEvent.readEvents( filter ) />

<cfoutput>#viewEvent.list( events, filter )#</cfoutput>