require_relative '../test_helper'

class ServerControllerTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_a_client
    post '/sources', {"rootUrl" => "abc.com", "identifier" => "abc"}
    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
  end

  def test_it_knows_about_missing_parameters
    post '/sources', {"rootUrl" => "abc.com"}

    assert_equal 400, last_response.status
    assert_equal "Missing Parameters", last_response.body
  end

  def test_it_knows_when_an_identifier_exists
    post '/sources', {"rootUrl" => "abc.com", "identifier" => "abc"}
    post '/sources', {"rootUrl" => "abc.com", "identifier" => "abc"}
    assert_equal 403, last_response.status
    assert_equal "Identifier Already Exists", last_response.body
  end

  def test_it_can_identify_an_unique_payload_request
    post '/sources', {"rootUrl" => "abc.com", "identifier" => "abc"}
    post '/sources/abc/data', "payload" =>'{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    assert_equal 200, last_response.status
    assert_equal "OK", last_response.body
  end

  def test_it_can_identify_a_missing_payload_request
    post '/sources', {"rootUrl" => "abc.com", "identifier" => "abc"}
    post '/sources/abc/data'

    assert_equal 400, last_response.status
    assert_equal "Bad Request", last_response.body
  end

  #to be advised
  def test_it_can_identify_duplicated_payload_requests
    post '/sources', {"rootUrl" => "abc.com", "identifier" => "abc"}
    post '/sources/abc/data', "payload" =>'{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    post '/sources/abc/data', "payload" =>'{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    assert_equal 403, last_response.status
    assert_equal "Payload already received", last_response.body
  end

  def test_it_application_has_not_been_registered
    post '/sources/abc/data', "payload" =>'{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    assert_equal 403, last_response.status
    assert_equal "Application not registered", last_response.body
  end

end
