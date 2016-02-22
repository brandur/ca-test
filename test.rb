require "base64"
require "rest-client"

url = "https://api.stripe.com/v1/charges"
key = ENV["STRIPE_API_KEY"] || abort("need STRIPE_API_KEY")

headers = {
  "Authorization" => "Basic #{Base64.urlsafe_encode64("#{key}:")}",
}

bundles = [
  { :name => "Empty bundle (should fail)",     :file => "./ca-empty.crt" },
  { :name => "New cert bundle (cURL/Mozilla)", :file => "./ca-certificates-new.crt" },
  { :name => "Old cert bundle (from Ubuntu)",  :file => "./ca-certificates-old.crt" },
  { :name => "rest-client default",            :file => nil },

  # Not 100% sure on this location.
  { :name => "Ubuntu system bundle",           :file => "/etc/ssl/certs/ca-certificates.crt" },
]

bundles.each do |info|
  begin
    puts "Running request for: #{info[:name]}"

    if info[:file] != nil && !File.exists?(info[:file])
      puts "Bundle not found at: #{info[:file]} ... skipping"
      next
    end

    RestClient::Request.execute(method: :get, url: url, headers: headers,
      ssl_ca_file: info[:file]
    )
    puts "verification suceeded"
  rescue RestClient::SSLCertificateNotVerified
    puts "verification FAILED"
  end
end
