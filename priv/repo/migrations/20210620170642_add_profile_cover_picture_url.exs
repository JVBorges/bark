defmodule Bark.Repo.Migrations.AddProfileCoverPictureUrl do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_pic_url, :string
      add :cover_pic_url, :string
    end
  end
end
