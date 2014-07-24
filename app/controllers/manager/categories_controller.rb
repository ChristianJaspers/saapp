class Manager::CategoriesController < Manager::ManagerController
  expose_decorated(:categories, ancestor: :team) { |relation| relation.order(name: :asc).page(params[:page]) }
  expose(:category, attributes: :category_params)

  layout 'manager'

  def show
    render json: category, root: false
  end

  def edit
    gon.category_id = category.id
  end

  def update
    respond_to do |format|
      format.json do
        if Manager::UpdateCategory.call(self).success?
          render json: 'success', status: :ok
        else
          render json: 'invalid', status: :unprocessable_entity
        end
      end
      format.html do
        if category.save
          redirect_to :back, notice: t('manager.categories.update.notifications.success')
        else
          redirect_to :back, error: t('manager.categories.update.notifications.failure')
        end
      end
    end
  end

  def destroy
    category.remove! if category.removable_by?(current_user)
    redirect_to :back, notice: t('manager.categories.destroy.notifications.success')
  end

  private

  def team
    current_user.team
  end

  def category_params
    params.require(:category).permit(:archive)
  end
end
