describe ThousandIsland do
  it { expect(described_class).to be_a(Module) }
  it { expect(KIsland).to be_a(Module) }
  it { expect(KIsland).to eq(described_class) }
end
