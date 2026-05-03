require "rails_helper"

RSpec.describe "Journal Entries Routes", type: :routing do
  describe "journal_entries routes" do
    it "routes GET /aurelius-press/journal-entries to aurelius_press/document/journal_entries#index" do
      expect(get("/aurelius-press/journal-entries")).to route_to("aurelius_press/document/journal_entries#index")
    end

    it "routes GET /aurelius-press/journal-entries/new to aurelius_press/document/journal_entries#new" do
      expect(get("/aurelius-press/journal-entries/new")).to route_to("aurelius_press/document/journal_entries#new")
    end

    it "routes POST /aurelius-press/journal-entries to aurelius_press/document/journal_entries#create" do
      expect(post("/aurelius-press/journal-entries")).to route_to("aurelius_press/document/journal_entries#create")
    end

    it "routes GET /aurelius-press/journal-entries/:id to aurelius_press/document/journal_entries#show" do
      expect(get("/aurelius-press/journal-entries/1")).to route_to("aurelius_press/document/journal_entries#show", id: "1")
    end

    it "routes GET /aurelius-press/journal-entries/:id/edit to aurelius_press/document/journal_entries#edit" do
      expect(get("/aurelius-press/journal-entries/1/edit")).to route_to("aurelius_press/document/journal_entries#edit", id: "1")
    end

    it "routes PATCH /aurelius-press/journal-entries/:id to aurelius_press/document/journal_entries#update" do
      expect(patch("/aurelius-press/journal-entries/1")).to route_to("aurelius_press/document/journal_entries#update", id: "1")
    end

    it "routes PUT /aurelius-press/journal-entries/:id to aurelius_press/document/journal_entries#update" do
      expect(put("/aurelius-press/journal-entries/1")).to route_to("aurelius_press/document/journal_entries#update", id: "1")
    end

    it "routes DELETE /aurelius-press/journal-entries/:id to aurelius_press/document/journal_entries#destroy" do
      expect(delete("/aurelius-press/journal-entries/1")).to route_to("aurelius_press/document/journal_entries#destroy", id: "1")
    end
  end

  describe "nested notes routes" do
    it "routes POST /aurelius-press/journal-entries/:id/notes to aurelius_press/document/notes#create" do
      expect(post("/aurelius-press/journal-entries/1/notes")).to route_to(
        "aurelius_press/document/notes#create",
        journal_entry_id: "1"
      )
    end

    it "routes PATCH /aurelius-press/journal-entries/:id/notes/:note_id to aurelius_press/document/notes#update" do
      expect(patch("/aurelius-press/journal-entries/1/notes/2")).to route_to(
        "aurelius_press/document/notes#update",
        journal_entry_id: "1",
        id: "2"
      )
    end

    it "routes DELETE /aurelius-press/journal-entries/:id/notes/:note_id to aurelius_press/document/notes#destroy" do
      expect(delete("/aurelius-press/journal-entries/1/notes/2")).to route_to(
        "aurelius_press/document/notes#destroy",
        journal_entry_id: "1",
        id: "2"
      )
    end
  end
end
