// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/effect-slide
//= require jquery-ui/draggable
//= require jquery-ui/droppable
//= require jquery-ui/widget
//= require jquery-ui/mouse
//= require jquery.ui.touch-punch
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require parsley
//= require twitter/typeahead
//= require select2
//= require pace/pace
//= require highcharts
//= require highcharts/highcharts-more
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

function ready() {
    // Enable parsley js validation
    $('form[data-validate="parsley"] .btn-primary').on('click', function(e) {
        $('form').parsley().validate();
    });
}

function addFoodToPlate(foodElement) {
    var foodId = foodElement.data('food-id');
    var foodName = foodElement.data('food-name');
    var swapTip = foodElement.data('swap-tip');
    $('.current-plate').append(foodElement.clone()
        .find('img')
        .attr('height', '75')
        .attr('width', '75')
        .addClass('food-on-plate img-circle')
        .attr('data-toggle', 'tooltip')
        .attr('data-placement', 'top')
        .attr('title', foodName).attr('id', foodId));

    var trHtml = '<tr class="food" data-food-id="'+ foodId +'"><td>' + foodName + '</td></tr>';
    $('.current-plate-details .delete-after-first').hide();
    $('.current-plate-details').find('tbody').append(trHtml);

    updateFoodCounter();

    $('[data-toggle="tooltip"]').tooltip()

    setRemoveFood($('.current-plate').children().last());

    if (swapTip != "") {
        $('.tip').html(swapTip);
    }
}


function setDrag(obj) {
    obj.draggable({
        revert: "invalid",
        helper: "clone",
        cursor: "move"
    });
}

function setAllFoodRemove() {
    $('.food-on-plate').on('click', function(e) {
        removeFood($(this));
    });
}

function setRemoveFood(food) {
    food.on('click', function(e) {
        removeFood($(this));
    })
}

function applyPlateOnClick() {
    $('plate').on('click', function(e) {
        if ($(this).hasClass('strobe')) {
            return;
        }
        else {
            togglePlates($(this).attr('id'));
        }
    })
}

function togglePlates(id) {
    $('.strobe').removeClass('strobe')
    $('.current-plate-details').removeClass('current-plate-details').addClass('hidden');
    $('.current-plate').removeClass('current-plate').addClass('hidden');

    $('plate[id='+ id +']').addClass('strobe');
    $('.plate-detail[id='+ id +']').removeClass('hidden').addClass('current-plate-details');
    $('.food-goes-here[id='+ id +']').removeClass('hidden').addClass('current-plate');
}

function updateFoodCounter() {
    var foodCounter = $('.strobe .food-counter');
    foodCounter.html($('.current-plate').find('img').length);
}

function removeFood(food) {
    var foodId = food.attr('id');
    food.remove();
    $('.current-plate-details tr.food[data-food-id='+ foodId +']').first().remove();
    if ($('.current-plate-details tr.food').length < 1) {
        $('.current-plate-details .delete-after-first').show();
    }
    updateFoodCounter();

    $('.tooltip.in').hide();
}

$(document).ready(ready)
$(document).on('page:load', ready)
