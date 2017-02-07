<div class="alert alert-success"><?php echo $page_message; ?></div>

<?php if (isset($pre_message) && $pre_message != '') { ?>
<div style="border:2px solid #ECECEC; border-radius: 3px; padding: 5px 5px 2px; margin: 1em 0; background: #eff0f2;">
    <?php echo $pre_message; ?>
</div>
<?php } ?>

<div style="border:2px solid #ECECEC; border-radius: 3px; padding: 5px 5px 2px; margin: 1em 0;">
	<table style="margin: 0; padding: 0; width: 100%; background-color: #FFFFFF; font-family: sans-serif;color: #2C3E50;">
		<tr>
			<th colspan="2" style="text-align:left;font-size:24px;padding-bottom:12px;"><?php echo $form_name; ?></th>
		</tr>
		<?php foreach ($email as $key => $value): ?>
			<?php $key = ucwords(str_replace('-', ' ', str_replace('_', ' ', $key))); ?>
			<tr>
				<td style="padding:1em;margin:0;background-color:#eff0f2;border-top-left-radius:5px;border-bottom-left-radius:5px; border-bottom: 1px solid #fff; border-right: 1px solid #fff;"><?php echo $key; ?></td>
				<td style="padding:1em;margin:0;background-color:#eff0f2;border-top-right-radius:5px;border-bottom-right-radius:5px; border-bottom: 2px solid #fff;"><?php echo $value; ?></td>
			</tr>
		<?php endforeach;?>
	</table>
</div>