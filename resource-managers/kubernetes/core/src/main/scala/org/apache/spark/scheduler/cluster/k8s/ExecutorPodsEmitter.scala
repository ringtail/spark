package org.apache.spark.scheduler.cluster.k8s

import scala.actors.Actor
import io.fabric8.kubernetes.client.KubernetesClient
import io.fabric8.kubernetes.api.model.Pod


private[spark] class ExecutorPodsEmitter(kubernetesClient: KubernetesClient) extends Actor {
  override def act(): Unit = {
    loop {
      react {
        // create executor with id
        case CreateExecutor(podWithAttachedContainer) => {
          kubernetesClient.pods().create(podWithAttachedContainer)
        }
      }
    }
  }
}

case class CreateExecutor(podWithAttachedContainer: Pod)