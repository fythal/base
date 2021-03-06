class InvoicesController < ApplicationController
  # GET /invoices
  # GET /invoices.json
before_filter :load_customers
        def index
                
    @invoices = @customer.invoices.all
    @articles = Article.con_nombre(params[:q]) if params[:q].present?
    @payments = 0
    @invoices.each do |e|
            @payments  += Payment.where('invoice_id = ?', e.id).sum(&:amount)
    end

    @amount = Invoice.total_amount
    @total = @amount - @payments

    respond_to do |format|

      format.html # index.html.erb
      format.json { render json: @invoices }
    end

  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = @customer.invoices.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
 
    @invoice = @customer.invoices.new
    1.times {@invoice.orders.build}
    1.times {@invoice.payments.build}

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @articles = Article.con_nombre(params[:q]) if params[:q].present?
    @invoice = @customer.invoices.new(params[:invoice])
    @id = @invoice.orders(params[:articles_id])
    @quantity = Article.quantity_order(@id)


    respond_to do |format|
      if @invoice.save
        format.html { redirect_to [@customer, @invoice], notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to [@customer, @invoice], notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end
  private

  def load_customers
          @customer = Customer.find(params[:customer_id])
  end


end
