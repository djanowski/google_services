require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'google', 'analytics')

describe Google::Analytics do
  before do
    Google::Analytics.stub!(:rails_env).and_return('production')
  end

  before :each do
    Google::Analytics.track nil
  end

  it "includes the GA JS file" do
    Google::Analytics.track "UA-XXXX-X"
    Google::Analytics.javascript_code.should match(Regexp.new(Regexp.escape('<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>')))
  end

  it "takes your GA tracker ID" do
    Google::Analytics.javascript_code.should be_blank

    Google::Analytics.track "UA-XXXX-X"
    Google::Analytics.javascript_code.should match(/UA-XXXX-X/)
  end

  it "only renders the tracking code on production mode" do
    Google::Analytics.track "UA-XXXX-X"
    Google::Analytics.javascript_code.should match(/^[^\/]*urchinTracker\(\);/)

    Google::Analytics.stub!(:rails_env).and_return('development')
    Google::Analytics.javascript_code.should_not match(/^[^\/]*urchinTracker\(\);/)
  end
end
