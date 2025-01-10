<section class="page-section cta">
            <div class="container">
                <div class="row">
                    <div class="col-xl-9 mx-auto">
                        <div class="cta-inner bg-faded text-center rounded">
</br>

<h2 class="section-heading mb-4">
<span class="section-heading-lower"><?php echo $titre; ?></span></h2>
</br>
<?= session()->getFlashdata('error') ?>
<?php echo form_open('/candidature/suivi'); ?>
<?= csrf_field() ?>



</br>

<h5>
<label for="ci">Code d'inscription : </label>
<input type="input" style="width:380px;" name="ci">
</br>

</br>
<label for="cc">Code de candidat : </label>
<input type="input" style="width:380px;" name="cc">
</br>

</br>
<input type="submit" class="btn btn-light btn-lg btn-block" name="submit" value="Visualiser">
</br>
<?= validation_show_error('ci') ?>
</br>
<?= validation_show_error('cc') ?>
<?php echo $t; ?>


</h5>
</form>
</div></div></div></div></section>