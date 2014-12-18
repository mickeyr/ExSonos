defmodule SonosController.Client do
  use HTTPoison.Base

  def process_url(endpoint) do
    url = "http://192.168.1.238:1400#{endpoint}"
    IO.inspect url
    url
  end

  def process_request_body(body) do
    new_body = """
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
        <s:Body>
          #{body}
        </s:Body>
      </s:Envelope>
    """
    IO.inspect new_body
    new_body
  end

  def process_request_headers(headers) do
    new_headers = [ {"Content-Type", "text/xml"} | headers ]
    IO.inspect new_headers
    new_headers
  end

  def process_response_body(body) do
    {:ok, body}
  end
end
