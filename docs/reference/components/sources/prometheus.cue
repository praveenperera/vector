package metadata

components: sources: prometheus: {
	title:             "Prometheus"
	short_description: "Ingests data through the [Prometheus text exposition format][urls.prometheus_text_based_exposition_format] and outputs metric events."
	long_description:  "[Prometheus][urls.prometheus] is a pull-based monitoring system that scrapes metrics from configured endpoints, stores them efficiently, and supports a powerful query language to compose dynamic information from a variety of otherwise unrelated data points."

	classes: {
		commonly_used: false
		delivery:      "at_least_once"
		deployment_roles: ["daemon", "sidecar"]
		development:   "beta"
		egress_method: "batch"
		function:      "collect"
	}

	features: {
		checkpoint: enabled: false
		multiline: enabled:  false
		tls: enabled:        false
	}

	support: {
		dependencies: {
			prometheus_client: {
				required: true
				title:    "Prometheus Client"
				type:     "external"
				url:      urls.prometheus_client
				versions: null

				interface: socket: {
					api: {
						title: "Prometheus"
						url:   urls.prometheus_text_based_exposition_format
					}
					direction: "outgoing"
					protocols: ["http"]
					ssl: "optional"
				}
			}
		}

		platforms: {
			"aarch64-unknown-linux-gnu":  true
			"aarch64-unknown-linux-musl": true
			"x86_64-apple-darwin":        true
			"x86_64-pc-windows-msv":      true
			"x86_64-unknown-linux-gnu":   true
			"x86_64-unknown-linux-musl":  true
		}

		requirements: []
		warnings: []
		notices: []
	}

	configuration: {
		endpoints: {
			description: "Endpoints to scrape metrics from."
			required:    true
			warnings: ["You must explicitly add the path to your endpoints. Vector will _not_ automatically add `/metics`."]
			type: array: {
				items: type: string: examples: ["http://localhost:9090/metrics"]
			}
		}
		scrape_interval_secs: {
			common:      true
			description: "The interval between scrapes, in seconds."
			required:    false
			warnings: []
			type: uint: {
				default: 15
				unit:    "seconds"
			}
		}
	}

	output: metrics: {
		counter:   output._passthrough_counter
		gauge:     output._passthrough_gauge
		histogram: output._passthrough_histogram
		summary:   output._passthrough_summary
	}
}
