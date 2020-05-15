Then /^a click should get logged$/ do
  expect(Click).to receive(:log)
end
