ActiveAdmin.register_page "Approve Games" do
  content title: proc{ 'Approve Games' } do
  #div class: "blank_slate_container", id: "dashboard_default_message" do
  #  span class: "blank_slate" do
  #    span I18n.t("active_admin.dashboard_welcome.welcome")
  #    small I18n.t("active_admin.dashboard_welcome.call_to_action")
  #  end
  #end

  # Here is an example of a simple dashboard with columns and panels.
  #
    columns do
      column do
        panel "Pending Approvals" do
          render partial: 'admin/approvals'
        end
      end
    end
  end
end