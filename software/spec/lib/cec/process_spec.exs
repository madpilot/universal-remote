defmodule CEC.Mapping.ProcessSpec do
  use ESpec

  describe "receiving lines from the port" do
    before do: allow GenServer |> to(accept :cast, fn(_, _) -> nil end)

    it "is cast to CEC.Producer" do
      expect(CEC.Process.handle_info({:ok, {:data, {:eol, "test"}}}, :state)) |> to(eq({:noreply, :state}))
      expect(GenServer) |> to(accepted :cast, [CEC.Producer, {:cec, "test"}])
    end
  end

  describe "sending a cec code" do
    let port: self()

    it "send the command code to the port" do
      CEC.Process.handle_call({:send_code, "00:11"}, self(), %{port: port()})
      assert_receive({_, {:command, "tx 00:11\n"}})
    end

    describe "#send_code" do
      before do: allow GenServer |> to(accept :call, fn(_, _) -> nil end)
      it "sends the command code to the port" do
        CEC.Process.send_code("00:11")
        expect(GenServer) |> to(accepted :call, [CEC.Process, {:send_code, "00:11"}])
      end
    end
  end
end
