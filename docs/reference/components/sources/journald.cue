package metadata

components: sources: journald: {
	title:             "#{component.title}"
	short_description: "Ingests data through [Systemd's][urls.systemd] [Journald][urls.journald] utility and outputs log events."
	long_description:  "[Journald][urls.journald] is a utility for accessing log data across a variety of system services. It was introduced with [Systemd][urls.systemd] to help system administrators collect, access, and route log data."

	classes: {
		commonly_used: true
		delivery:      "at_least_once"
		deployment_roles: ["daemon"]
		development:   "beta"
		egress_method: "batch"
		function:      "collect"
	}

	features: {
		checkpoint: enabled: true
		multiline: enabled:  false
		tls: enabled:        false
	}

	support: {
		dependencies: {
			journald: {
				required: true
				title:    "JournalD"
				type:     "external"
				url:      urls.journald
				versions: null

				interface: binary: {
					name: "journalctl"
					permissions: unix: group: "systemd-journal"
				}
			}
		}

		platforms: {
			"aarch64-unknown-linux-gnu":  true
			"aarch64-unknown-linux-musl": true
			"x86_64-apple-darwin":        false
			"x86_64-pc-windows-msv":      false
			"x86_64-unknown-linux-gnu":   true
			"x86_64-unknown-linux-musl":  true
		}

		requirements: []
		warnings: []
		notices: []
	}

	configuration: {
		batch_size: {
			common:      false
			description: "The systemd journal is read in batches, and a checkpoint is set at the end of each batch. This option limits the size of the batch."
			required:    false
			warnings: []
			type: uint: {
				default: 16
				unit:    null
			}
		}
		current_boot_only: {
			common:      true
			description: "Include only entries from the current boot."
			required:    false
			warnings: []
			type: bool: default: true
		}
		exclude_units: {
			common:      true
			description: "The list of unit names to exclude from monitoring. Unit names lacking a `\".\"` will have `\".service\"` appended to make them a valid service unit name."
			required:    false
			warnings: []
			type: array: {
				default: []
				items: type: string: examples: ["badservice", "sysinit.target"]
			}
		}
		include_units: {
			common:      true
			description: "The list of unit names to monitor. If empty or not present, all units are accepted. Unit names lacking a `\".\"` will have `\".service\"` appended to make them a valid service unit name."
			required:    false
			warnings: []
			type: array: {
				default: []
				items: type: string: examples: ["ntpd", "sysinit.target"]
			}
		}
		journalctl_path: {
			common:      false
			description: "The full path of the `journalctl` executable. If not set, Vector will search the path for `journalctl`."
			required:    false
			warnings: []
			type: string: {
				default: "journalctl"
				examples: ["/usr/local/bin/journalctl"]
			}
		}
		remap_priority: {
			common:      false
			description: "If the record from journald contains a `PRIORITY` field, it will be remapped into the equivalent syslog priority level name using the standard (abbreviated) all-capitals names such as `EMERG` or `ERR`."
			required:    false
			warnings: []
			type: bool: default: false
		}
	}

	examples: [
		{
			title: "Sample Output"
			configuration: {}
			input: #"""
				```text
				2019-07-26 20:30:27 reply from 192.168.1.2: offset -0.001791 delay 0.000176, next query 1500s
				```
				"""#
			output: [{
				log: {
					timestamp:                _values.current_timestamp
					message:                  "reply from 192.168.1.2: offset -0.001791 delay 0.000176, next query 1500s"
					host:                     _values.local_host
					"__REALTIME_TIMESTAMP":   "1564173027000443"
					"__MONOTONIC_TIMESTAMP":  "98694000446"
					"_BOOT_ID":               "124c781146e841ae8d9b4590df8b9231"
					"SYSLOG_FACILITY":        "3"
					"_UID":                   "0"
					"_GID":                   "0"
					"_CAP_EFFECTIVE":         "3fffffffff"
					"_MACHINE_ID":            "c36e9ea52800a19d214cb71b53263a28"
					"PRIORITY":               "6"
					"_TRANSPORT":             "stdout"
					"_STREAM_ID":             "92c79f4b45c4457490ebdefece29995e"
					"SYSLOG_IDENTIFIER":      "ntpd"
					"_PID":                   "2156"
					"_COMM":                  "ntpd"
					"_EXE":                   "/usr/sbin/ntpd"
					"_CMDLINE":               "ntpd: [priv]"
					"_SYSTEMD_CGROUP":        "/system.slice/ntpd.service"
					"_SYSTEMD_UNIT":          "ntpd.service"
					"_SYSTEMD_SLICE":         "system.slice"
					"_SYSTEMD_INVOCATION_ID": "496ad5cd046d48e29f37f559a6d176f8"
				}
			}]
		},
	]
}
