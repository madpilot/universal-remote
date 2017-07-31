# Universal Remote - Elixir edition

This is, what will become a nerves firmware that will run on a RaspberryPi (and anyother nerves compatible hardware).

This provides the base modules for common functionality, broken up in to rough sections:

### Hardware interfaces

* LIRC
* CEC

### Software interfaces

* Web API
* MQTT

### Configuration

* A captivate portal for WiFi configuration
* Customisation application.

## Design

### Example

My receiver has CEC built in, but like most CEC implementations, it's a bit broken. For example, while it allows me to change the HDMI input up or down, I can't select an input by number.

Now, I can set the active source to a HDMI address, but it means I can change to AV1, which is what my Sonos is connected to. I do know that my sonos is three inputs after HDMI 4, so by setting the input to HDMI 4, then hitting input change three times, I can simulate the effect I need.

The custom module might look like this

```elixir
defmodule Device.Receiver do
  def power_on do
    CEC.SystemAudioControl(user_pressed, :recording_1, :audio_system, :power_on)
  end

  def hdmi1 do
    CEC.OneTouchPlay.active_source(:recording_1, :audio_system, CEC.address(cec, Device.AppleTV))
    wait(source: :audio_system, code: :active_source, address: CEC.address(cec, Device.AppleTV))
  end

  def hdmi4 do
    CEC.OneTouchPlay.active_source(:recording_1, :audio_system, CEC.address(cec, Device.Satellite))
    CEC.wait(source: :audio_system, code: :active_source, address: CEC.address(cec, Device.Satellite))
  end

  def input_change do
    CEC.SystemAudioControl.user_pressed(:recording_1, :audio_system, :select_av_function)
    CEC.wait(100)
    CEC.SystemAudioControl.user_released(:recording_1, :audio_system)
  end

  def av1 do
    CEC.Receiver.hdmi4
    CEC.Receiver.input_change
  end

  def av4 do
    CEC.Receiver.hdmi4
    CEC.Receiver.input_change
    wait(100)
    CEC.Receiver.input_change
    wait(100)
    CEC.Receiver.input_change
    wait(100)
  end
end

CEC.register("3.4.0.0", :audio_system, Device.Receiver)
CEC.register("3.4.0.1", :playback_1, Device.AppleTV)
CEC.register("3.4.0.4", [:tuner_1, :recording_1], Device.Satellite)
```

The last line tells the CEC listener that device at node 3.4.0.0 is the audio system (device id 44) and is defined by our CEC.Receiver module

You would define all the function for each piece of hardware this way. You can also create virutal devices allowing you to group real hardware so they act as one.

Let say, to watch Foxtel (pay TV if you aren't Australian), you need to turn the TV on; you also need to turn on the receiver, and switch it to HDMI 1; and finally turn on the Foxtel box. A Foxtel module might look like this:

```elixir
defmodule LIRC.Foxtel do
  def key_power do
    LIRC.send("foxtel", "KEY_POWER")
  end
end

defmodule CEC.TV do
  def power_on do
    CEC.send(:unregistered, :tv, :user_control_pressed, :power_on)
  end
end

defmodule Foxtel do
  def power_on do
    LIRC.Foxtel.send(:power_on)

    CEC.TV.send(:power_on)

    CEC.Receiver.send(:power_on)
    |> wait(1000)
    |> CEC.Receiver.send(:hdmi1)
  end
end

Foxtel
|> Web.register('foxtel')
|> MQTT.register('foxtel')
```

The last couple of lines registers the Foxtel module with the Web server and MQTT server (with the name "foxtel") so you can turn on this virtual device from both APIs

Finally, You can also register APIs with inputs, and get notifications when things like volume changes occur

```elixir
Web
|> LIRC.Notification.register
|> CEC.Notification.register
```

(TODO: This needs to be thought out a bit more...)


Here is the sonos example to wrap up the reciever example

```elixir
defmodule Sonos do
  def select do
    CEC.Receiver.send(:power_on)
    |> wait(1000)
    |> CEC.Receiver.send(:av4)
  end
end
```

### Running

To start Universal Remote:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
