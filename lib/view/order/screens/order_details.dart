import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickfix/state/constants.dart';
import 'package:quickfix/state/order/models/order.dart';
import 'package:quickfix/state/order/models/order_status.dart';
import 'package:quickfix/state/order/providers/can_cancel.dart';
import 'package:quickfix/state/order/repository/update_order.dart';
import 'package:quickfix/state/product/providers/product_by_id.dart';
import 'package:quickfix/view/components/boolean_dialog.dart';
import 'package:quickfix/view/components/main_button.dart';
import 'package:quickfix/view/extensions/formated_datetime.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  // Cancel order
  cancelOrder() async {
    // Show dialog to cofirm
    bool? confirmed = await showBooleanDialog(
      context: context,
      title: 'Are you sure you want to cancel?',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Items',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          ...widget.order.items.map((e) => Text(e.name)),
        ],
      ),
      trueText: 'Yes',
      falseText: 'No',
    );

    if (confirmed != true) {
      return;
    }
    bool canCancel = await ref.read(CanCancelProvider(widget.order).future);
    if (canCancel) {
      bool cancelled = await ref
          .read(updateOrderProvider.notifier)
          .updateOrderStatus(
              orderId: widget.order.id, orderStatus: OrderStatus.cancelled);
      if (cancelled) {
        showSnackbar();
      }
    }
  }

  showSnackbar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Order cancelled!')));
  }

  @override
  Widget build(BuildContext context) {
    final canCancel = ref.watch(canCancelProvider(widget.order));
    final updateOrderLoading = ref.watch(updateOrderProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Details',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('Order date')),
                        Expanded(
                            child:
                                Text(widget.order.timestamp.formatedString()))
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text('Total cost')),
                        Expanded(
                          child: Text(
                              '\u{20B9} ${widget.order.items.fold<int>(0, (previousValue, element) => previousValue + element.subtotal)}'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text('Expected Delivery')),
                        Expanded(
                          child: Text(widget.order.timestamp
                              .add(const Duration(days: 3))
                              .toString()),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Product Details',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: widget.order.items.map((e) {
                    final product = ref.watch(ProductByIdProvider(e.productId));
                    return product.when(
                      data: (product) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Image.network(
                                (product!.images.isEmpty)
                                    ? ''
                                    : product.images.first,
                                width: 200,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.image, size: 40),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(height: 10),
                                    Text('Quantity: ${e.quantity}'),
                                    Text(
                                      '\u{20B9} ${e.price}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                      error: (error, stackTrace) => Container(),
                      loading: () => Shimmer.fromColors(
                        baseColor: Colors.blueGrey.shade100,
                        highlightColor: Colors.white,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Payment & Address',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text('Payment status')),
                        Expanded(
                          child: Text(widget.order.isCashOnDelivery
                              ? 'Pay On Delivery'
                              : 'Paid'),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: Text('Address')),
                        Expanded(
                          child: Text(widget.order.shippingAddress.toString()),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (widget.order.orderStatus == OrderStatus.pending)
                canCancel.when(
                    data: (bool canCancel) {
                      if (canCancel) {
                        return MainButton(
                          onPressed: updateOrderLoading ? () {} : cancelOrder,
                          backgroundColor: updateOrderLoading
                              ? Colors.redAccent
                              : Colors.red,
                          child: updateOrderLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text(
                                  'Cancel order',
                                  style: TextStyle(color: Colors.white),
                                ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: const Text(
                            'Order cannot be cancelled $cancelWithinHours hours after placed'),
                      );
                    },
                    error: (e, st) => Text(e.toString()),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
