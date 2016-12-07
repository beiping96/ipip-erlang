{application, ap,
	[
		 {description, "ipip test"}
		,{vsn, "0.1.0"}
		,{modules, [ap]}
		,{registered, [ap_sup]}
		,{applications, [kernel, stdlib]}
		,{mod, {ap, []}}
		,{start_phases, []}
		,{env, []}
	]
}.
