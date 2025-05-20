require 'rails_helper'

RSpec.describe Role, type: :model do
  describe "validations" do
    let(:role) do
        Role.new(name: "admin")
    end
    it "role is valid" do
        expect(role).to be_valid
    end
    context "when validations fail" do
        let(:role) do
            Role.new(name: nil)
        end
        it "name is empty" do
            expect(role).not_to be_valid
            role.valid? # errors rempli qu'après l'avoir appelé ou une méthode qui déclenche la validation (save ou create ...) ici on appelle explicitement role.valid? avant de vérifier les erreurs.
            expect(role.errors[:name]).to include("Le nom du rôle ne peut être vide.")
        end
    end
    describe "when role is valid and unique" do
            let(:role) do
                Role.create!(name: "admin")
            end
            it "role is created" do
                expect(role).to be_valid
                expect(role.name).to eq("admin")
            end
            context "role is valid but not unique" do
                before { Role.create!(name: "admin") }
                it "create role fails" do
                    # role
                    duplicate = Role.new(name: "admin")
                    duplicate.valid?
                    expect(duplicate).not_to be_valid
                    expect(duplicate.errors[:name]).to include("Le nom de rôle existe déjà.")
                end
            end
        end
    end
    describe "associations" do
        let(:role) do
            Role.create!(name: "admin")
        end
        let(:role_2) do
            Role.create!(name: "editor")
        end
         let(:user) do
            User.create!(
              email_address: "test@example.com",
              password: "azerty",
              name: "test",
              last_name: "name"
            )
        end
        let(:user_2)  do
            User.create!(
                email_address: "test2@example.com",
                password: "hello",
                name: "test2",
                last_name: "name2"
            )
        end
        it "one role can be assign to one user" do
            role.users << user
            expect(role.users).to match_array([ user ])
        end
        it "one role can be assigned to several users" do
            role.users << user
            role.users << user_2
            # expect(user.roles).to eq([ role ])
            expect(role.users).to match_array([ user, user_2 ])
        end
        it "several roles can be assigned to one user" do
            role.users << user
            role_2.users << user
            expect(role.users).to match_array([ user ])
            expect(role_2.users).to match_array([ user ])
        end
    end
end
