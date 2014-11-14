class Manager::ProductGroupsController < Manager::ManagerController
  expose_decorated(:product_groups, ancestor: :team) { |relation| relation.sorted.page(params[:page]) }
  expose(:product_group, attributes: :product_group_params)

  def show
    render json: product_group, root: false
  end

  def create
    product_group.owner = current_user

    if product_group.save
      redirect_to edit_manager_product_group_path(product_group, locale: I18n.locale)
    else
      render :index
    end
  end

  def edit
    gon.product_group_id = product_group.id
  end

  def update
    respond_to do |format|
      format.json do
        if Manager::UpdateProductGroup.call(self).success?
          render json: 'success', status: :ok
        else
          render json: 'invalid', status: :unprocessable_entity
        end
      end
      format.html do
        if Manager::UpdateProductGroupPublishStatus.call(self).success?
          redirect_to :back, notice: t('manager.product_groups.update.notifications.success')
        else
          redirect_to :back, error: t('manager.product_groups.update.notifications.failure')
        end
      end
    end
  end

  def destroy
    product_group.remove! if product_group.removable_by?(current_user)
    redirect_to :back, notice: t('manager.product_groups.destroy.notifications.success')
  end

  def sort
    product_group = product_groups.find(params[:id])
    product_group.insert_at(params[:position].to_i)
    head :ok
  end

  private

  def team
    current_user.team
  end

  def product_group_params
    params.require(:product_group).permit(:archive, :name)
  end
end
