@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [],
  import: [],
  mappings: [
    "servers.web.enabled": [
      commented: false,
      datatype: [enum: [true, false]],
      default: true,
      doc: "Enable the web server.",
      hidden: false,
      to: "universal_remote.servers.web.enabled"
    ],
    "servers.web.scheme": [
      commented: false,
      datatype: [enum: [:http, :https]],
      default: :https,
      doc: "Wwebserver scheme.",
      hidden: false,
      to: "universal_remote.servers.web.scheme"
    ],
    "servers.web.bind": [
      commented: false,
      datatype: :binary,
      default: "0.0.0.0",
      doc: "IP address to bind to. Default: 0.0.0.0",
      hidden: false,
      to: "universal_remote.servers.web.options.ip"
    ],
    "servers.web.port": [
      commented: false,
      datatype: :integer,
      default: 4001,
      doc: "Port to listen to. Default: 4001",
      hidden: false,
      to: "universal_remote.servers.web.options.port"
    ],
    "servers.web.ssl.keyfile": [
      commented: true,
      datatype: :binary,
      default: "",
      doc: "Full path to the SSL certificate key",
      hidden: false,
      to: "universal_remote.servers.web.options.keyfile"
    ],
    "servers.web.ssl.certfile": [
      commented: true,
      datatype: :binary,
      default: "",
      doc: "Full path to the SSL certificate",
      hidden: false,
      to: "universal_remote.servers.web.options.certfile"
    ],
    "buses": [
      commented: false,
      datatype: [
        [list: :atom],
      ],
      default: [
        CEC.Supervisor,
        LIRC.Supervisor
      ],
      doc: "List of communication buses.",
      hidden: false,
      to: "universal_remote.buses.modules"
    ],
    "buses.cec.path.cec_client": [
      commented: false,
      datatype: :binary,
      default: "/usr/bin/cec-client",
      doc: "Path to the cec-client executable",
      hidden: false,
      to: "universal_remote.Elixir.CEC.Process.executable"
    ],
    "buses.lirc.path.irsend": [
      commented: false,
      datatype: :binary,
      default: "/usr/bin/irsend",
      doc: "Path to the irsend executable",
      hidden: false,
      to: "universal_remote.Elixir.LIRC.Process.irsend"
    ],
    "buses.lirc.path.irw": [
      commented: false,
      datatype: :binary,
      default: "/usr/bin/irw",
      doc: "Path to the irw executable",
      hidden: false,
      to: "universal_remote.Elixir.LIRC.Process.irw"
    ],
    "logger.backends": [
      commented: false,
      datatype: [
        datatype: [enum: [:console]],
      ],
      default: [
        :console
      ],
      doc: "List of logger backends.",
      hidden: false,
      to: "logger.backends"
    ],
    "logger.console.colors.enabled": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Enable color for the console logger",
      hidden: false,
      to: "logger.console.colors.enabled"
    ],
    "logger.console.format": [
      commented: false,
      datatype: :binary,
      default: "[$level] $message\\n",
      doc: "Set the format of the console logger.",
      hidden: false,
      to: "logger.console.format"
    ],
    "logger.console.utc_log": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Set console log timestamps to UTC",
      hidden: false,
      to: "logger.console.utc_log"
    ],
    "logger.console.level": [
      commented: false,
      datatype: [enum: [:debug, :info, :warn, :error]],
      default: :info,
      doc: "Logging level for the console logger. Default: info",
      hidden: false,
      to: "logger.console.level"
    ]
  ],
  transforms: [
    "servers.web.bind": fn conf ->
      Apex.ap conf
      Apex.ap Conform.Conf.get(conf, "servers.web.bind")

      case Conform.Conf.get(conf, "servers.web.bind") do
        str -> str |> String.split(".") |> List.to_tuple
      end
    end
  ],
  validators: []
]
