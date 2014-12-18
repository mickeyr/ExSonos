defmodule SonosController.API do
  alias SonosController.Client, as: Client
  require Record

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def pause do
    Client.post!("/MediaRenderer/AVTransport/Control", 
      "<u:Pause xmlns:u='urn:schemas-upnp-org:service:AVTransport:1'><InstanceID>0</InstanceID><Speed>1</Speed></u:Pause>",
      [{"SOAPACTION", "urn:schemas-upnp-org:service:AVTransport:1#Pause"}])
  end

  def play do
    Client.post!("/MediaRenderer/AVTransport/Control", 
      "<u:Play xmlns:u='urn:schemas-upnp-org:service:AVTransport:1'><InstanceID>0</InstanceID><Speed>1</Speed></u:Play>",
      [{"SOAPACTION", "urn:schemas-upnp-org:service:AVTransport:1#Play"}])
  end
  
  def next do
    Client.post!("/MediaRenderer/AVTransport/Control", 
      "<u:Next xmlns:u='urn:schemas-upnp-org:service:AVTransport:1'><InstanceID>0</InstanceID><Speed>1</Speed></u:Next>",
      [{"SOAPACTION", "urn:schemas-upnp-org:service:AVTransport:1#Next"}])
  end

  def prev do
    Client.post!("/MediaRenderer/AVTransport/Control", 
      "<u:Previous xmlns:u='urn:schemas-upnp-org:service:AVTransport:1'><InstanceID>0</InstanceID><Speed>1</Speed></u:Previous>",
      [{"SOAPACTION", "urn:schemas-upnp-org:service:AVTransport:1#Previous"}])
  end

  def toggle_mute do
    toggled_mute_value = rem(get_mute() + 1,  2)
    Client.post!("/MediaRenderer/RenderingControl/Control", 
      "<u:SetMute xmlns:u='urn:schemas-upnp-org:service:RenderingControl:1'><InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>#{toggled_mute_value}</DesiredMute></u:SetMute>",
      [{"SOAPACTION", "urn:schemas-upnp-org:service:RenderingControl:1#SetMute"}])
  end

  def get_mute do
    %HTTPoison.Response{status_code: 200, body: body} = Client.post!("/MediaRenderer/RenderingControl/Control", 
      "<u:GetMute xmlns:u='urn:schemas-upnp-org:service:RenderingControl:1'><InstanceID>0</InstanceID><Channel>Master</Channel></u:GetMute>",
      [{"SOAPACTION", "urn:schemas-upnp-org:service:RenderingControl:1#GetMute"}])

      xml_text = elem(body, 1)
      {xml, _rest} = :xmerl_scan.string(:erlang.bitstring_to_list(xml_text))
      [current_mute_node] = :xmerl_xpath.string('//CurrentMute', xml)
      [text_node] = xmlElement(current_mute_node, :content)

      xmlText(text_node, :value)
      |> to_string
      |> Integer.parse
      |> elem(0)
      
  end
end
